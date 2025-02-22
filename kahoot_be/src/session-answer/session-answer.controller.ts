import { Controller, Post, Body, HttpStatus, UseGuards, Res } from '@nestjs/common';
import { SessionAnswerService } from './session-answer.service';
import { CreateSessionAnswerDto } from './dto/create-session-answer.dto';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { Response } from 'express';

@Controller('session-answer')
@ApiTags('SessionAnswer')
export class SessionAnswerController {
  constructor(private readonly sessionAnswerService: SessionAnswerService) {}

  @Post('/')
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  async create(@Res() res: Response, @Body() createSessionAnswerDto: CreateSessionAnswerDto): Promise<Response<any>> {
    try {
      let newSessionAnswer = await this.sessionAnswerService.createSessionAnswer({...createSessionAnswerDto});
      return res.status(HttpStatus.CREATED).json(newSessionAnswer);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }
}
