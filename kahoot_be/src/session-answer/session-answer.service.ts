import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSessionAnswerDto } from './dto/create-session-answer.dto';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class SessionAnswerService {
  prisma = new PrismaClient();

  async createSessionAnswer(
    createSessionAnswerDto: CreateSessionAnswerDto,
  ): Promise<any> {
    try {
      console.log(createSessionAnswerDto);
      
      const sessionExists = await this.prisma.gameSessions.findUnique({
        where: { session_id: createSessionAnswerDto.session_id },
      });

      const userExists = await this.prisma.users.findUnique({
        where: { user_id: createSessionAnswerDto.user_id },
      });

      if (!sessionExists) {
        throw new NotFoundException(
          `Session with ID ${createSessionAnswerDto.session_id} not found.`,
        );
      }

      if (!userExists) {
        throw new NotFoundException(
          `User with ID ${createSessionAnswerDto.user_id} not found.`,
        );
      }

      console.log(userExists);
      

      const newSessionAnswer = await this.prisma.sessionAnswers.create({
        data: {
          session_id: createSessionAnswerDto.session_id,
          user_id: createSessionAnswerDto.user_id,
          answers_json: createSessionAnswerDto.answers_json,
          answered_at: new Date(),
        },
      });

      return newSessionAnswer;
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during create session answer',
      );
    }
  }
}
