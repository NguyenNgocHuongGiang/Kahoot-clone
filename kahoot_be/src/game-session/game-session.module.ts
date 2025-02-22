import { Module } from '@nestjs/common';
import { GameSessionService } from './game-session.service';
import { GameSessionGateway } from './game-session.gateway';
import { GameSessionController } from './game-session.controller';

@Module({
    controllers: [GameSessionController],
  providers: [GameSessionGateway, GameSessionService],
})
export class GameSessionModule {}
