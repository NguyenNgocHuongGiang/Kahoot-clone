import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  HttpStatus,
  Res,
  Put,
} from '@nestjs/common';
import { SessionPlayerService } from './session-player.service';
import { CreateSessionPlayerDto } from './dto/create-session-player.dto';
import { UpdateSessionPlayerDto } from './dto/update-session-player.dto';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { Response } from 'express';

@Controller('session-player')
@ApiTags('SessionPlayer')
export class SessionPlayerController {
  constructor(private readonly sessionPlayerService: SessionPlayerService) {}

  @Post('/')
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
  async create(
    @Res() res: Response,
    @Body() createSessionPlayerDto: CreateSessionPlayerDto,
  ): Promise<Response<CreateSessionPlayerDto>> {
    try {
      const gameSession = await this.sessionPlayerService.createSessionPlayer(
        createSessionPlayerDto,
      );
      return res.status(HttpStatus.CREATED).json(gameSession);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Put(':id')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Update successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async updatePlayerSession(
    @Res() res: Response,
    @Param('id') id: string,
    @Body() updateSessionPlayerDto: UpdateSessionPlayerDto,
  ): Promise<Response<CreateSessionPlayerDto>> {
    try {
      console.log(id);
      
      const gameSession = await this.sessionPlayerService.update(
        +id,
        updateSessionPlayerDto,
      );
      return res.status(HttpStatus.OK).json(gameSession);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Get('get-player/:sessionId')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getPlayersBySessionId(
    @Res() res: Response,
    @Param('sessionId') sessionId: string,
  ): Promise<Response<any>> {
    try {
      const players = await this.sessionPlayerService.getPlayersBySessionId(sessionId);
      return res.status(HttpStatus.OK).json(players);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }


  @Get('get-top-player/:sessionId')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getTopPlayersBySessionId(
    @Res() res: Response,
    @Param('sessionId') sessionId: string,
  ): Promise<Response<any>> {
    try {
      const players = await this.sessionPlayerService.getTopPlayersBySessionId(sessionId);
      return res.status(HttpStatus.OK).json(players);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }


  @Get('get-history-quiz/:userId')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getHistoryByUserId(
    @Res() res: Response,
    @Param('userId') userId: string,
  ): Promise<Response<any>> {
    try {
      const players = await this.sessionPlayerService.getHistoryByUserId(Number(userId));
      return res.status(HttpStatus.OK).json(players);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }
}
