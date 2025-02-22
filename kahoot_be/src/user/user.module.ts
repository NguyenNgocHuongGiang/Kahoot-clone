import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { QuizModule } from 'src/quiz/quiz.module';

@Module({
  imports: [QuizModule],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}
