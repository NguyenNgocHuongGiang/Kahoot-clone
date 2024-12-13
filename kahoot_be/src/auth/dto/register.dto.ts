import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ description: "User's fullname" })
  @IsString()
  full_name: string;

  @ApiProperty({ description: "Username" })
  @IsString()
  username: string

  @ApiProperty({ description: "User's email" })
  @IsEmail()
  email: string;

  @ApiProperty({ description: "User's password" })
  @IsString()
  @MinLength(6)
  password: string;
}
