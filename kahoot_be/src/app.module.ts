import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import {ConfigModule} from '@nestjs/config'
import { AuthModule } from './auth/auth.module';
import { QuizModule } from './quiz/quiz.module';
import { UserModule } from './user/user.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { QuestionModule } from './question/question.module';
import { OptionsModule } from './options/options.module';
import { GameSessionModule } from './game-session/game-session.module';
import { SessionPlayerModule } from './session-player/session-player.module';
import { SessionAnswerModule } from './session-answer/session-answer.module';
import {FileUploadModule } from './file-upload/file-upload.module';
import { GroupStudyModule } from './group-study/group-study.module';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'), 
    }),
    QuizModule, 
    ConfigModule.forRoot({isGlobal: true}), 
    AuthModule, 
    UserModule, 
    QuestionModule, 
    OptionsModule, GameSessionModule, SessionPlayerModule, SessionAnswerModule, 
    FileUploadModule, GroupStudyModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
