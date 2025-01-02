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
      console.log("body:",body);
      
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
        where:{ creator: user_id}
      });
      return quizzes.map((quiz) => plainToClass(QuizDto, quiz));
    } catch (error) {
      throw new Error(error);
    }
  }

  findOne(id: number) {
    return this.prisma.quizzes.findUnique({
      where: { quiz_id: id },
      include: {
        Questions: {
          include: {
            Options: true, 
          },
        }
      },
    });
  }

  update(id: number, updateQuizDto: UpdateQuizDto) {
    return `This action updates a #${id} quiz`;
  }

  async remove(id: number) : Promise<QuizDto>{
    try {
      const quizDeleted = await this.prisma.quizzes.delete({
        where: { quiz_id: id },
      });
      return plainToClass(QuizDto, quizDeleted);
    } catch (error) {
      throw new Error(error);
    }
  }
}
