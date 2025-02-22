import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { IoAdapter } from '@nestjs/platform-socket.io';
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const configService = app.get(ConfigService)

  //add validation input
  app.useGlobalPipes(new ValidationPipe());

  app.enableCors({
    origin: '*', 
    methods: 'GET,POST,PUT,DELETE', 
    allowedHeaders: 'Content-Type, Authorization',
  });

  app.useWebSocketAdapter(new IoAdapter(app));

  const configSwagger = new DocumentBuilder()
  .setTitle('Quiz Fox')
  .setVersion("1.0")
  .addBearerAuth()
  .build()  //builder pattern
  
  const swagger = SwaggerModule.createDocument(app, configSwagger)
  SwaggerModule.setup("swagger", app, swagger)
  
  const port = configService.get<number>('PORT') || 8080

  await app.listen(port);
}
bootstrap();
