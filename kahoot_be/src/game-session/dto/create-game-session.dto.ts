import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsOptional, IsDate, IsEnum, IsInt } from 'class-validator';

export enum GameSessionsStatus {
  PLAYING = 'playing',
  ACTIVE = 'active',
  INACTIVE = 'comp',
}

export class CreateGameSessionDto {
  @IsOptional()
  session_id: number;

  @IsNotEmpty()
  @IsInt()
  @ApiProperty()
  quiz_id: number;

  @IsOptional()
  @IsString()
  pin?: string;

  @IsOptional()
  @IsEnum(GameSessionsStatus)
  status?: GameSessionsStatus; 

  @IsOptional()
  @IsDate()
  start_time?: Date;

  @IsOptional()
  @IsDate()
  end_time?: Date;

  @IsNotEmpty()
  @IsString()
  @ApiProperty()
  host: string;
}
