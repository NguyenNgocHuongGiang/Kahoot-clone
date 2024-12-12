import { Injectable } from '@nestjs/common';
import { CreateQuizDto } from './dto/create-quiz.dto';
import { UpdateQuizDto } from './dto/update-quiz.dto';
import { PrismaClient } from '@prisma/client';
import { plainToClass } from 'class-transformer';
import { QuizDto } from './dto/quiz.dto';

@Injectable()
export class QuizService {
  prisma  = new PrismaClient()

  create(createQuizDto: CreateQuizDto) {
    return 'This action adds a new quiz';
  }

  async findAll() {
    try {
      let quizzes =  await this.prisma.quizzes.findMany()
      return quizzes.map(quiz => plainToClass(QuizDto, quiz))
    } catch (error) {
      throw new Error(error)
    }
  }

  findOne(id: number) {
    return `This action returns a #${id} quiz`;
  }

  update(id: number, updateQuizDto: UpdateQuizDto) {
    return `This action updates a #${id} quiz`;
  }

  remove(id: number) {
    return `This action removes a #${id} quiz`;
  }
}
