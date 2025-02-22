import { Body, Controller, HttpStatus, Post, Res } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { Response } from 'express';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { LoginDto } from './dto/login.dto';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/register')
  @ApiResponse({ status: HttpStatus.OK, description: 'Register successfullly' })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async register(
    @Body() registerDto: RegisterDto,
    @Res() res: Response,
  ): Promise<Response<string>> {
    try {
      const result = await this.authService.register(registerDto);
      return res.status(HttpStatus.OK).json(result);
    } catch (error) {
      if (error.message === 'User already exists') {
        return res
          .status(HttpStatus.CONFLICT)
          .json({ message: 'User already exists' });
      }
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(error);
    }
  }

  @Post('/login')
  @ApiResponse({ status: HttpStatus.OK, description: 'Login successfullly' })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async login(
    @Body() body: LoginDto,
    @Res() res: Response,
  ): Promise<Response<string>> {
    try {
      const result = await this.authService.login(body);
      return res.status(HttpStatus.OK).json(result);
    } catch (error) {
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(error);
    }
  }
}
