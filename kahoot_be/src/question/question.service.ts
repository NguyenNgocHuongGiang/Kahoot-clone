import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, PrismaClient } from '@prisma/client';
import { CreateQuestionDto } from './dto/create-question.dto';
import { QuestionDto } from './dto/question.dto';

@Injectable()
export class QuestionsService {
  prisma = new PrismaClient();

  async create(body: CreateQuestionDto): Promise<QuestionDto> {
    try {
      const newQuestion = await this.prisma.questions.create({
        data: body,
      });
      return newQuestion;
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during create question',
      );
    }
  }

  // async findAll() {
  //   return await this.prisma.questions.findMany();
  // }

  // async findByQuestionId(question_id: number) {
  //   const question = await this.prisma.questions.findUnique({
  //     where: { question_id },
  //   });

  //   if (!question) {
  //     throw new NotFoundException('Question not found');
  //   }

  //   return question;
  // }

  // async update(
  //   question_id: number,
  //   data: Prisma.QuestionsUpdateInput,
  // ) {
  //   const question = await this.prisma.questions.findUnique({
  //     where: { question_id },
  //   });

  //   if (!question) {
  //     throw new NotFoundException('Question not found');
  //   }

  //   return await this.prisma.questions.update({
  //     where: { question_id },
  //     data,
  //   });
  // }

  // async remove(question_id: number) {
  //   const question = await this.prisma.questions.findUnique({
  //     where: { question_id },
  //   });

  //   if (!question) {
  //     throw new NotFoundException('Question not found');
  //   }

  //   return await this.prisma.questions.delete({
  //     where: { question_id },
  //   });
  // }
}
