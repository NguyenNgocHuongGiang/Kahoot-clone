import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  HttpStatus,
  UseGuards,
  Res,
  NotFoundException,
  Put
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
  // @ApiBearerAuth()
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  // @UseGuards(AuthGuard)
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

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.questionService.findByQuestionId(+id);
  }

  @Put(':id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Update successful',
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'Question not found',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal server error',
  })
  // @UseGuards(AuthGuard)
  async update(
    @Param('id') id: string,
    @Body() updateQuestionDto: UpdateQuestionDto,
    @Res() res: Response
  ): Promise<Response<QuestionDto>> {
    try {
      const updatedQuestion = await this.questionService.update(+id, updateQuestionDto);
      return res.status(HttpStatus.OK).json(updatedQuestion);
    } catch (error) {
      if (error instanceof NotFoundException) {
        return res.status(HttpStatus.NOT_FOUND).json({ message: error.message });
      }
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }
  
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Delete successful',
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'Question not found',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal server error',
  })
  @Delete(':id')
  async remove(@Param('id') id: string, @Res() res: Response) : Promise<Response<any>> {
    try {
      const deletedQuestion = await this.questionService.remove(+id)
      return res.status(HttpStatus.OK).json(deletedQuestion);
    } catch (error) {
      if (error instanceof NotFoundException) {
        return res.status(HttpStatus.NOT_FOUND).json({ message: error.message });
      }
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }
}
