import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsInt, IsNotEmpty, IsOptional, IsString, Min } from 'class-validator';

export class CreateQuestionDto {
  @IsInt()
  @Min(1)
  @ApiProperty()
  quiz_id: number;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  question_text: string;

  @ApiProperty()
  @IsEnum(['multiple_choice', 'true_false', 'open_ended', 'puzzle', 'poll'])
  question_type: 'multiple_choice' | 'true_false' | 'open_ended' | 'puzzle' | 'poll';

  @IsString()
  @IsOptional()
  @ApiProperty()
  media_url?: string;

  @IsInt()
  @Min(0)
  @IsOptional()
  @ApiProperty()
  time_limit?: number;

  @IsInt()
  @Min(0)
  @IsOptional()
  @ApiProperty()
  points?: number;
}
