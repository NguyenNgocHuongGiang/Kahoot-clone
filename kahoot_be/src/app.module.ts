import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import {ConfigModule} from '@nestjs/config'
import { AuthModule } from './auth/auth.module';
import { QuizModule } from './quiz/quiz.module';

@Module({
  imports: [
    QuizModule, 
    ConfigModule.forRoot({isGlobal: true}), AuthModule // load bien moi truong
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
