import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsOptional, Min } from 'class-validator';

export class GetMessagesDto {

  @ApiProperty()
  group_id: number;


  @ApiProperty()
  page?: number;

  @ApiProperty()
  limit?: number; 
}
