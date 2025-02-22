import {
  Controller,
  Post,
  Body,
  HttpStatus,
  Res,
  UseGuards,
  Get,
  Param,
  Put,
} from '@nestjs/common';
import { GameSessionService } from './game-session.service';
import { CreateGameSessionDto } from './dto/create-game-session.dto';
import { ApiBearerAuth, ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { GameSessionGateway } from './game-session.gateway';
import { AuthGuard } from 'src/auth/auth.guard';
import { JoinGameSessionDto } from './dto/join-game.dto';
import { CreateQuizSnapshotDto } from './dto/create-quiz-snapshots';
import { GameSessionsStatus } from './dto/create-game-session.dto';

@ApiTags('GameSessions')
@Controller('game-sessions')
export class GameSessionController {
  constructor(
    private readonly gameSessionService: GameSessionService,
    private readonly gameSessionGateway: GameSessionGateway,
  ) {}

  @Post('/create')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async createGameSession(
    @Res() res: Response,
    @Body() createGameSessionDto: CreateGameSessionDto,
  ): Promise<Response<any>> {
    try {
      const gameSession = await this.gameSessionService.createGameSession(
        createGameSessionDto.quiz_id,
        createGameSessionDto.host,
      );

      this.gameSessionGateway.server.emit('game-session-created', {
        pin: gameSession.pin,
        host: gameSession.host,
      });

      return res
        .status(HttpStatus.CREATED)
        .json({ gameSession, pin: gameSession.pin });
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Get(':pin')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfully',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server Error',
  })
  async getGameSession(
    @Res() res: Response,
    @Param('pin') pin: string,
  ): Promise<Response<any>> {
    try {
      const gameSession =
        await this.gameSessionService.getGameSessionByPin(pin);
      return res.status(HttpStatus.OK).json({ gameSession });
    } catch (error) {
      return res
        .status(HttpStatus.BAD_REQUEST)
        .json({ message: error.message });
    }
  }

  @Get('/get-session-by-id/:id')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfully',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server Error',
  })
  async getGameSessionById(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      console.log(id);

      const gameSession = await this.gameSessionService.getGameSessionById(id);
      return res.status(HttpStatus.OK).json({ gameSession });
    } catch (error) {
      return res
        .status(HttpStatus.BAD_REQUEST)
        .json({ message: error.message });
    }
  }

  @Get('/get-session-by-quiz-id/:id')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfully',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server Error',
  })
  async getGameSessionByQuizId(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      const gameSession = await this.gameSessionService.getGameSessionByQuizId(id);
      return res.status(HttpStatus.OK).json({ gameSession });
    } catch (error) {
      return res
        .status(HttpStatus.BAD_REQUEST)
        .json({ message: error.message });
    }
  }

  @Get('/get-report-by-session-id/:id')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfully',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server Error',
  })
  async getDetailSessionGame(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      const gameSession = await this.gameSessionService.getReportBySessionId(Number(id));
      return res.status(HttpStatus.OK).json({ gameSession });
    } catch (error) {
      return res
        .status(HttpStatus.BAD_REQUEST)
        .json({ message: error.message });
    }
  }

  @Post('/create-snapshots')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async createQuizSnapshots(
    @Res() res: Response,
    @Body() snapshots: CreateQuizSnapshotDto,
  ): Promise<Response<any>> {
    try {
      const quizSnapshots = await this.gameSessionService.createQuizSnapshot(
        snapshots.sessionId,
        snapshots.quizId,
        snapshots.userId,
        snapshots.quizData,
      );
      return res.status(HttpStatus.CREATED).json(quizSnapshots);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Put(':id')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiBody({
    description: 'The new status of the game session',
    required: true,
    schema: {
      type: 'object',
      properties: {
        status: { type: 'string', enum: ['active', 'playing', 'inactive'] }, 
      },
    },
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Updated successfully',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server Error',
  })
  async updateGameSessionStatus(
    @Res() res: Response,
    @Param('id') sessionId: number,
    @Body() updateGameSessionDto: { status: GameSessionsStatus },
  ): Promise<Response<any>> {
    
    try {
      const updatedGameSession =
        await this.gameSessionService.updateGameSessionStatus(
          sessionId,
          updateGameSessionDto.status,
        );

      return res
        .status(HttpStatus.OK)
        .json({ updatedGameSession, status: updatedGameSession.status });
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }
}
