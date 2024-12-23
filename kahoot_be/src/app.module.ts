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
    OptionsModule 
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
