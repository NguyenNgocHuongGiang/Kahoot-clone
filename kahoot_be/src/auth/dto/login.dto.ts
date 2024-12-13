import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsNotEmpty } from "class-validator";

export class LoginDto{
    @IsEmail({}, {message: "Email is wrong format"})
    @ApiProperty()
    email:string;

    @IsNotEmpty({message: "Password can't be empty"})
    @ApiProperty()
    password: string
}