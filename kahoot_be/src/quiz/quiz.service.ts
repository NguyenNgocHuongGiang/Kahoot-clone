import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { CreateQuizDto } from './dto/create-quiz.dto';
import { UpdateQuizDto } from './dto/update-quiz.dto';
import { PrismaClient } from '@prisma/client';
import { plainToClass } from 'class-transformer';
import { QuizDto } from './dto/quiz.dto';

@Injectable()
export class QuizService {
  prisma = new PrismaClient();

  async create(body: CreateQuizDto): Promise<QuizDto> {
    try {
      const newQuiz = await this.prisma.quizzes.create({
        data: body,
      });
      console.log('new quiz', newQuiz);

      return plainToClass(QuizDto, newQuiz);
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during create quiz',
      );
    }
  }

  async findAll() {
    try {
      let quizzes = await this.prisma.quizzes.findMany();
      return quizzes.map((quiz) => plainToClass(QuizDto, quiz));
    } catch (error) {
      throw new Error(error);
    }
  }

  async findManyByUserId(user_id: string) {
    try {
      let quizzes = await this.prisma.quizzes.findMany({
        where: { creator: user_id },
      });
      return quizzes.map((quiz) => plainToClass(QuizDto, quiz));
    } catch (error) {
      throw new Error(error);
    }
  }

  async findOne(id: number) {
    if (id) {
      return await this.prisma.quizzes.findUnique({
        where: { quiz_id: id },
        include: {
          Questions: {
            include: {
              Options: true,
            },
          },
        },
      });
    }
  }

  async update(id: number, updateQuizDto: UpdateQuizDto): Promise<QuizDto> {
    try {
      const updatedQuiz = await this.prisma.quizzes.update({
        where: { quiz_id: id },
        data: updateQuizDto,
      });
      return plainToClass(QuizDto, updatedQuiz);
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred while updating the quiz',
      );
    }
  }

  async remove(id: number): Promise<QuizDto> {
    try {
      const quizDeleted = await this.prisma.quizzes.delete({
        where: { quiz_id: id },
      });
      return plainToClass(QuizDto, quizDeleted);
    } catch (error) {
      throw new Error(error);
    }
  }

  async getTopQuiz(): Promise<any> {
    try {
      const publicQuiz = await this.prisma.quizzes.findMany({
        where: {
          visibility: 'public',
        },
      });


      const quizIds = publicQuiz.map((q) => q.quiz_id);

      const sessions = await this.prisma.gameSessions.findMany({
        where: {
          quiz_id: { in: quizIds },
        },
      });
      const sessionIds = sessions.map((s) => s.session_id);

      const players = await this.prisma.sessionPlayers.findMany({
        where: { session_id: { in: sessionIds } },
        select: { session_id: true, session_player_id: true }, 
      });

      const playerCountByQuiz: Record<number, number> = {};

      sessions.forEach((session) => {
        const sessionId = session.session_id;
        const quizId = session.quiz_id;
        const playerCount = players.filter(
          (p) => p.session_id === sessionId,
        ).length;

        playerCountByQuiz[quizId] =
          (playerCountByQuiz[quizId] || 0) + playerCount;
      });

      const sortedQuizzes = publicQuiz
        .map((quiz) => ({
          ...quiz,
          totalPlayers: playerCountByQuiz[quiz.quiz_id] || 0,
        }))
        .sort((a, b) => b.totalPlayers - a.totalPlayers)
        .slice(0, 10);
      return sortedQuizzes;

    } catch (error) {
      throw new Error(error);
    }
  }
}
