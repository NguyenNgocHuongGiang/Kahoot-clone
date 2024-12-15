import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaClient } from '@prisma/client';
import { User } from './entities/user.entity';

@Injectable()
export class UserService {
  prisma = new PrismaClient();

  // create(createUserDto: CreateUserDto) {
  //   return 'This action adds a new user';
  // }

  // findAll() {
  //   return `This action returns all user`;
  // }

  async findOne(id: number): Promise<User> {
    return this.prisma.users.findUnique({
      where: { user_id: id },
    });
  }

  async update(id: number, updateData: UpdateUserDto): Promise<User> {
    const user = await this.prisma.users.findUnique({
      where: { user_id: id },
    });

    if (!user) {
      throw new Error('User not found');
    }

    return this.prisma.users.update({
      where: { user_id: id },
      data: updateData,
    });
  }

  // remove(id: number) {
  //   return `This action removes a #${id} user`;
  // }
}
