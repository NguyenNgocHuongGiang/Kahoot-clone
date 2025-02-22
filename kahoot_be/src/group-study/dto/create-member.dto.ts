import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNotEmpty } from 'class-validator';

export class CreateGroupMemberDto {
  @IsInt()
  @ApiProperty()
  @IsNotEmpty()
  group_id: number;

  @IsInt()
  @IsNotEmpty()
  @ApiProperty()
  user_id: number;
}
