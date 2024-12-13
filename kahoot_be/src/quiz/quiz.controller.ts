import {
  Controller,
  Get,
  Post,
  Body,
  Put,
  Param,
  Delete,
  HttpStatus,
  Res,
} from '@nestjs/common';
import { QuizService } from './quiz.service';
import { CreateQuizDto } from './dto/create-quiz.dto';
import { UpdateQuizDto } from './dto/update-quiz.dto';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { QuizDto } from './dto/quiz.dto';

@ApiTags('Quizzes')
@Controller('quiz')
export class QuizController {
  constructor(private readonly quizService: QuizService) {}

  @Post('/')
  @ApiResponse({ status: HttpStatus.CREATED, description: 'Create successfullly' })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async create(@Res() res: Response, @Body() createQuizDto: CreateQuizDto): Promise<Response<QuizDto>> {
    try {
      let newQuiz = await this.quizService.create(createQuizDto);
      return res.status(HttpStatus.CREATED).json(newQuiz);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }


  @Get('/get-all-quizzes')
  @ApiResponse({ status: HttpStatus.OK, description: 'Get successfullly' })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async findAll(@Res() res: Response): Promise<Response<QuizDto[]>> {
    try {
      let quizzes = await this.quizService.findAll();
      return res.status(HttpStatus.OK).json(quizzes);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  // @Get(':id')
  // findOne(@Param('id') id: string) {
  //   return this.quizService.findOne(+id);
  // }

  // @Patch(':id')
  // update(@Param('id') id: string, @Body() updateQuizDto: UpdateQuizDto) {
  //   return this.quizService.update(+id, updateQuizDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.quizService.remove(+id);
  // }
}
