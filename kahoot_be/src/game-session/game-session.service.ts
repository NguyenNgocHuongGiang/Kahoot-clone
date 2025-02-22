import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import {
  CreateGameSessionDto,
  GameSessionsStatus,
} from './dto/create-game-session.dto';
import { PrismaClient } from '@prisma/client';
import { GameSessionGateway } from './game-session.gateway';
import { log } from 'console';

@Injectable()
export class GameSessionService {
  prisma = new PrismaClient();

  constructor(private readonly gameSessionGateway: GameSessionGateway) {}

  async getGameSessionByPin(pin: string): Promise<any> {
    return this.prisma.gameSessions.findFirst({
      where: { pin: pin },
    });
  }

  async getGameSessionById(id: string): Promise<any> {
    return this.prisma.gameSessions.findFirst({
      where: { session_id: parseInt(id) },
    });
  }

  async createGameSession(
    quizId: number,
    host: string,
  ): Promise<CreateGameSessionDto> {
    try {
      const pin = Math.random()
        .toString(10)
        .substr(2, 6)
        .toUpperCase()
        .replace(/[A-Z]/g, '');
      const session = await this.prisma.gameSessions.create({
        data: {
          quiz_id: quizId,
          pin,
          host,
        },
      });

      this.gameSessionGateway.server.emit('game-session-created', {
        pin: session.pin,
        host: session.host,
      });

      return {
        session_id: session.session_id,
        quiz_id: session.quiz_id,
        pin: session.pin,
        host: session.host,
        status: session.status as GameSessionsStatus,
        start_time: session.start_time,
        end_time: session.end_time,
      };
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during create game session',
      );
    }
  }

  async createQuizSnapshot(
    sessionId: number,
    quizId: number,
    user_id: number,
    quizData: object,
  ) {
    // const existingSnapshot = await this.prisma.quizSnapshots.findFirst({
    //   where: {
    //     session_id: sessionId,
    //     quiz_id: quizId,
    //   },
    // });

    const quiz = await this.prisma.quizzes.findFirst({
      where: {
        quiz_id: quizId,
      },
    });

    // if (quiz.visibility == 'private') {
    //   if (existingSnapshot) {
    //     return existingSnapshot;
    //   }
    // }

    try {
      const sessionIdCheck = await this.prisma.gameSessions.findMany({
        where: {
          session_id: sessionId,
        },
      });

      const quizIdCheck = await this.prisma.quizzes.findMany({
        where: {
          quiz_id: quizId,
        },
      });

      if (!sessionIdCheck || !quizIdCheck) {
        throw new Error('Not found');
      }

      const data = {
        session_id: sessionId,
        quiz_id: quizId,
        user_id: user_id,
        quiz_data: quizData,
      };

      const snapshot = await this.prisma.quizSnapshots.create({ data });
      return snapshot;
    } catch (error) {
      console.error('Error creating quiz snapshot:', error);
      throw new Error('Failed to create quiz snapshot');
    }
  }

  async updateGameSessionStatus(
    sessionId: number,
    status: GameSessionsStatus,
  ): Promise<CreateGameSessionDto> {
    console.log(status);
    console.log(sessionId);

    try {
      const session = await this.prisma.gameSessions.findFirst({
        where: {
          session_id: parseInt(sessionId.toString()),
        },
      });
      const updatedSession = await this.prisma.gameSessions.update({
        where: {
          session_id: session.session_id,
        },
        data: {
          ...session,
          status: status as any,
        },
      });

      return {
        session_id: updatedSession.session_id,
        quiz_id: updatedSession.quiz_id,
        pin: updatedSession.pin,
        host: updatedSession.host,
        status: updatedSession.status as GameSessionsStatus,
        start_time: updatedSession.start_time,
        end_time: updatedSession.end_time,
      };
    } catch (error) {
      console.log(error);
      throw new InternalServerErrorException(
        'An error occurred during updating the game session status',
      );
    }
  }

  async getGameSessionByQuizId(id: string): Promise<any> {
    return this.prisma.gameSessions.findMany({
      where: { quiz_id: parseInt(id) },
    });
  }

  async getReportBySessionId(sessionId: number): Promise<any> {
    let playerDetails = [];

    const session = await this.prisma.gameSessions.findUnique({
      where: {
        session_id: sessionId,
      },
    });

    const players = await this.prisma.sessionPlayers.findMany({
      where: {
        session_id: sessionId,
      },
    });

    const playerCount = players.length;

    const quiz = await this.prisma.quizzes.findUnique({
      where: {
        quiz_id: session.quiz_id,
      },
      include: {
        Questions: {
          include: {
            Options: true,
          },
        },
      },
    });

    const questionsCount = quiz.Questions.length;

    const correctAnswersMap = new Map();

    quiz.Questions.forEach((question, index) => {
      const correctOption = question.Options.find((opt) => opt.is_correct);
      if (correctOption) {
        correctAnswersMap.set(index, correctOption.option_id);
      }
    });

    const questionStats: Record<number, { text: string; value: number }> = {};
    quiz.Questions.forEach((question) => {
      questionStats[question.question_id] = { text: '', value: 0 };
    });

    if (quiz.visibility == 'public') {
      await Promise.all(
        players.map(async (player, index) => {
          const playerAnswers = await this.prisma.sessionAnswers.findMany({
            where: {
              session_id: sessionId,
            },
          });

          const maxQuestionIndex = Math.max(
            ...Array.from(correctAnswersMap.keys()),
            1,
          );
          const correctAnswersObject = Object.fromEntries(
            Array.from({ length: maxQuestionIndex + 1 }, (_, index) => [
              index.toString(),
              correctAnswersMap.has(index) ? correctAnswersMap.get(index) : -1,
            ]),
          );

          console.log(111111111111);

          if (index == 0) {
            if (playerAnswers) {
              playerAnswers.map((user) => {
                let correctAnswersCount = 0;
                const answers = user.answers_json;

                console.log('correctAnswersObject:', correctAnswersObject);
                try {
                  Object.keys(correctAnswersObject).forEach((key) => {
                    const questionIndex = Number(key);
                    console.log(
                      `Checking key: ${key}, Index: ${questionIndex}`,
                    );
                    if (!quiz.Questions || !Array.isArray(quiz.Questions)) {
                      console.error(
                        'quiz.Questions is not an array or is undefined!',
                      );
                      return;
                    }

                    if (!quiz.Questions[questionIndex]) {
                      console.error(
                        `quiz.Questions[${questionIndex}] is undefined! Skipping...`,
                      );
                      return;
                    }

                    // console.log(quiz.Questions[Number(key)]['question_id']);

                    // const questionId = quiz.Questions[Number(key)].question_id;
                    const questionId =
                      quiz.Questions[Number(key)]['question_id'];

                    questionStats[questionId].text =
                      quiz.Questions[Number(key)]['question_text'];

                    console.log(questionStats[questionId].text);

                    if (answers[key] === correctAnswersObject[key]) {
                      console.log(222222222222);

                      correctAnswersCount++;
                      // const questionId = quiz.Questions[Number(key)].question_id;
                      const questionId =
                        quiz.Questions[Number(key)]['question_id'];
                      console.log(questionStats[questionId].value);

                      // questionStats[questionId].text =
                      //   quiz.Questions[Number(key)].question_text;
                      questionStats[questionId].value++;
                      console.log(questionStats[questionId].value);
                    }
                  });
                } catch (error) {
                  console.error('Error inside forEach:', error);
                }
                console.log(333333333333333);

                console.log(correctAnswersCount);

                playerDetails.push({
                  correctAnswers: correctAnswersCount,
                });

                console.log(playerDetails);
              });
            }
          }

          playerDetails.forEach((detail, index) => {
            if (detail) {
              detail.playerId = players[index].user_id;
              detail.score = players[index].score;
              detail.nickname = players[index].nickname;
            }
          });
        }),
      );
    } else {
      playerDetails = await Promise.all(
        players.map(async (player) => {
          const playerAnswers = await this.prisma.sessionAnswers.findMany({
            where: {
              user_id: player.user_id,
              session_id: sessionId,
            },
          });

          let correctAnswersCount = 0;
          if (playerAnswers) {
            const maxQuestionIndex = Math.max(
              ...Array.from(correctAnswersMap.keys()),
              1,
            );
            const correctAnswersObject = Object.fromEntries(
              Array.from({ length: maxQuestionIndex + 1 }, (_, index) => [
                index.toString(),
                correctAnswersMap.has(index)
                  ? correctAnswersMap.get(index)
                  : -1,
              ]),
            );
            const answers = playerAnswers.map((pa) => pa.answers_json)[0];

            Object.keys(correctAnswersObject).forEach((key) => {
              const questionId = quiz.Questions[Number(key)].question_id;
              questionStats[questionId].text =
                quiz.Questions[Number(key)].question_text;
              if (answers[key] == correctAnswersObject[key]) {
                correctAnswersCount++;
                const questionId = quiz.Questions[Number(key)].question_id;
                // questionStats[questionId].text =
                //   quiz.Questions[Number(key)].question_text;
                questionStats[questionId].value++;
              }
            });

            console.log(questionStats);
          }
          return {
            playerId: player.user_id,
            nickname: player.nickname,
            correctAnswers: correctAnswersCount,
            score: player.score,
          };
        }),
      );
    }

    return {
      playerCount,
      questionsCount,
      playerDetails,
      questionStats,
    };
  }
}
