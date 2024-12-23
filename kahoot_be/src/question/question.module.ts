import { Module } from '@nestjs/common';
import { QuestionsService } from './question.service';
import { QuestionController } from './question.controller';

@Module({
  controllers: [QuestionController],
  providers: [QuestionsService],
})
export class QuestionModule {}
