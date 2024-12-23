import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsBoolean,
  IsOptional,
  IsInt,
  MinLength,
} from 'class-validator';

export class CreateOptionDto {
  @IsInt()
  @IsOptional()
  @ApiProperty()
  question_id: number;

  @IsString()
  @MinLength(1)
  @ApiProperty()
  option_text: string;

  @IsBoolean()
  @ApiProperty()
  is_correct: boolean;
}
