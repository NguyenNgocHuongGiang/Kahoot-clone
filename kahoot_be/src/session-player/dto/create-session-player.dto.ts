import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsOptional, IsInt, IsDate } from 'class-validator';

export class CreateSessionPlayerDto {
  @IsNotEmpty()
  @IsInt()
  @ApiProperty({ description: 'The ID of the session' })
  session_id: number;

  @IsNotEmpty()
  @IsInt()
  @ApiProperty({ description: 'The ID of the user' })
  user_id: number;

  @IsNotEmpty()
  @IsString()
  @ApiProperty({ description: 'The nickname of the user in the session', maxLength: 50 })
  nickname: string;

  @IsOptional()
  @IsInt()
  @ApiProperty({ description: 'The score of the user', default: 0 })
  score?: number;

  @IsOptional()
  @IsDate()
  //@ApiProperty({ description: 'The time when the user joined the session', default: () => new Date() })
  join_time?: Date;
}
