import { BadRequestException, Injectable, InternalServerErrorException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { RegisterDto } from './dto/register.dto';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  prisma = new PrismaClient();

  constructor(
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(registerDto: RegisterDto) {
    const { email, password, full_name, username, avatar } = registerDto;

    const userExists = await this.prisma.users.findUnique({
      where: { email },
    });

    if (userExists) {
      throw new Error('User already exists');
    }

    const defaultAvatar = '/images/default-avatar.jpg';

    const userNew = await this.prisma.users.create({
      data: {
        full_name: full_name,
        email: email,
        password: bcrypt.hashSync(password, 10),
        username: username || '',
        avatar: defaultAvatar,
      },
    });

    return userNew;
  }

  async login(body: LoginDto): Promise<string> {
    try {
      const { email, password } = body;

      const checkUser = await this.prisma.users.findFirst({
        where: { email },
      });
      if (!checkUser) {
        throw new BadRequestException('Email is incorrect');
      }

      const checkPass = bcrypt.compareSync(password, checkUser.password);
      if (!checkPass) {
        throw new BadRequestException('Password is incorrect');
      }

      const token = this.jwtService.sign(
        { data: { userId: checkUser.user_id } },
        {
          expiresIn: '30m',
          secret: this.configService.get('SECRET_KEY'),
        },
      );
      return token;
    } catch (error) {
      if (error instanceof BadRequestException) {
        throw error; 
      } else {
        throw new InternalServerErrorException('An error occurred during login');
      }
    }
  }
}
