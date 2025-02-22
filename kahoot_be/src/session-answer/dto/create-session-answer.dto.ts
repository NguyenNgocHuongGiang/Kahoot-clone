import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsOptional, IsObject } from 'class-validator';

export class CreateSessionAnswerDto {
  @IsInt()
  @ApiProperty()
  session_id: number;

  @IsInt()
  @ApiProperty()
  user_id: number;

  @IsObject()
  @ApiProperty()
  answers_json: Record<number, number | null>;

  @IsOptional()
  @IsInt()
  answered_at?: number;
}
