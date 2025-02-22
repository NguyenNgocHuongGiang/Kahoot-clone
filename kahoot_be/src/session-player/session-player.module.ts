import { Module } from '@nestjs/common';
import { SessionPlayerService } from './session-player.service';
import { SessionPlayerController } from './session-player.controller';

@Module({
  controllers: [SessionPlayerController],
  providers: [SessionPlayerService],
})
export class SessionPlayerModule {}
