import { Module } from '@nestjs/common';
import { SessionAnswerService } from './session-answer.service';
import { SessionAnswerController } from './session-answer.controller';

@Module({
  controllers: [SessionAnswerController],
  providers: [SessionAnswerService],
})
export class SessionAnswerModule {}
