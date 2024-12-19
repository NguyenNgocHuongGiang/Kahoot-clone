import { IsString, IsEmail, IsOptional, IsPhoneNumber, Matches } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @IsOptional()
  username?: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsString()
  @IsOptional()
  password?: string;

  @IsOptional()
  @IsString()
  full_name?: string;

  @IsOptional() 
  @Matches(/^\d{10,15}$/, { message: 'Phone must be a valid phone number with 10-15 digits.' })
  phone?: string;

  @IsOptional() 
  @IsString()
  avatar?: string;
}
