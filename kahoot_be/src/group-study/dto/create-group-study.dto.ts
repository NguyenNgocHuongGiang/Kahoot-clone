import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsString } from 'class-validator';

export class CreateGroupStudyDto {
    @IsString()
    @ApiProperty()
    @IsNotEmpty()
    group_name: string;
  
    @IsInt()
    @ApiProperty()
    created_by: number;
}
