import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpStatus,
  UseGuards,
  Res
} from '@nestjs/common';
import { QuestionsService } from './question.service';
import { CreateQuestionDto } from './dto/create-question.dto';
import { UpdateQuestionDto } from './dto/update-question.dto';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { AuthGuard } from 'src/auth/auth.guard';
import { QuestionDto } from './dto/question.dto';

@Controller('question')
@ApiTags('Question')
export class QuestionController {
  constructor(private readonly questionService: QuestionsService) {}

  @Post('/')
  @ApiBearerAuth()
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  @UseGuards(AuthGuard)
  async create(@Res() res: Response, @Body() createQuestionDto: CreateQuestionDto): Promise<Response<QuestionDto>> {
    try {
      let newQuestion = await this.questionService.create(
        {
          ...createQuestionDto,
        }
      );
      return res.status(HttpStatus.CREATED).json(newQuestion);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  // @Get()
  // findAll() {
  //   return this.questionService.findAll();
  // }

  // @Get(':id')
  // findOne(@Param('id') id: string) {
  //   return this.questionService.findOne(+id);
  // }

  // @Patch(':id')
  // update(@Param('id') id: string, @Body() updateQuestionDto: UpdateQuestionDto) {
  //   return this.questionService.update(+id, updateQuestionDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.questionService.remove(+id);
  // }
}
