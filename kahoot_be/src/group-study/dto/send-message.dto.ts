import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsString } from 'class-validator';

export class SendMessageDto {
  @IsInt()
  @ApiProperty()
  group_id: number;

  @IsInt()
  @ApiProperty()
  user_id: number;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  message: string;
}
