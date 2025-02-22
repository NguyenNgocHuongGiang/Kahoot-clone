import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { CreateSessionPlayerDto } from './dto/create-session-player.dto';
import { UpdateSessionPlayerDto } from './dto/update-session-player.dto';
import { PrismaClient } from '@prisma/client';
import { ExceptionsHandler } from '@nestjs/core/exceptions/exceptions-handler';

@Injectable()
export class SessionPlayerService {
  prisma = new PrismaClient();
  
  async createSessionPlayer(data: CreateSessionPlayerDto) : Promise<CreateSessionPlayerDto> {
    try {
      return this.prisma.sessionPlayers.create({
        data: {
          session_id: data.session_id,
          user_id: data.user_id,
          nickname: data.nickname,
          score: data.score,
          join_time: data.join_time,
        },
      });
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during create game session',
      );
    }
  }

  async update(id: number, updateSessionPlayerDto: UpdateSessionPlayerDto) {
    try {
      return await this.prisma.sessionPlayers.update({
        where: {
          session_player_id: id,
        },
        data: {
          nickname: updateSessionPlayerDto.nickname,
          score: updateSessionPlayerDto.score,
          join_time: updateSessionPlayerDto.join_time,
        },
      });
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during update game session player',
      );
    }
  }

  async getPlayersBySessionId(sessionId: string): Promise<{ user_id: number, nickname: string, host: string }[]> {
    try {
      const response = await this.prisma.gameSessions.findUnique({
        where: { session_id: parseInt(sessionId) },
        select: {
          host: true, 
          SessionPlayers: {
            select: {
              user_id: true,
              nickname: true
            }
          }
        }
      });
  
      if (!response) {
        return [{ user_id: 0, nickname: '', host: '' }];
      }
  
      const playersWithHost = response.SessionPlayers
        .filter(player => player.user_id !== Number(response.host)) 
        .map(player => ({
          ...player,
          host: response.host 
        }));
  
      console.log('Players with host:', playersWithHost);
      return playersWithHost;
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred while retrieving players and host for the session',
      );
    }
  }
  
  async getTopPlayersBySessionId(sessionId: string): Promise<{ user_id: number, nickname: string, score: number }[]> {
    try {
      return await this.prisma.sessionPlayers.findMany({
        where: { session_id: parseInt(sessionId) },
        orderBy: {
          score: 'desc',
        },
        take: 3,
        select: {
          user_id: true,
          nickname: true,
          score: true,
        },
      });
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred while retrieving the top players for the session',
      );
    }
  }
  
  async getHistoryByUserId(userId: number): Promise<any> {
    try {
      console.log(userId);
      
      const playerSessions = await this.prisma.sessionPlayers.findMany({
        where: {
          user_id: userId
        },
        select: {
          session_id: true
        }
      });

      console.log(playerSessions.length);
      
      
      if (playerSessions.length === 0) {
        throw new InternalServerErrorException(
          'Not Found',
        );
      }
      
      const sessionIds = playerSessions.map(session => session.session_id);

      console.log(sessionIds);
      
      
      const snapshots = await this.prisma.quizSnapshots.findMany({
        where: {
          session_id: {
            in: sessionIds
          },
          user_id: userId
        }
      });

      console.log(snapshots);


      const answers = await this.prisma.sessionAnswers.findMany({
        where: {
          session_id: {
            in: sessionIds
          },
          user_id: userId
        },
        select:{
          session_id: true,
          answers_json: true
        }
      });

      const answersMap = new Map<number, any[]>();
      answers.forEach(answer => {
        if (!answersMap.has(answer.session_id)) {
          answersMap.set(answer.session_id, []);
        }
        answersMap.get(answer.session_id).push(answer);
      });

      // console.log(answersMap);
      
      const snapshotsWithAnswers = snapshots.map(snapshot => ({
        ...snapshot,
        answers: answersMap.get(snapshot.session_id),
      }));

      return snapshotsWithAnswers
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred while retrieving players and host for the session',
      );
    }
  }
}
