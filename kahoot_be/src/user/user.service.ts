import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaClient } from '@prisma/client';
import { User } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

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

    if (updateData.password) {
      if (user.password === updateData.password) {
        const { password, ...rest } = updateData;
        const updateUser = {
          ...rest,
        };
        return this.prisma.users.update({
          where: { user_id: id },
          data: updateUser,
        });
      } else {
        const hashNewPassword = bcrypt.hashSync(updateData.password, 10);
        const updateUser = {
          ...updateData,
          password: hashNewPassword,
        };
        return this.prisma.users.update({
          where: { user_id: id },
          data: updateUser,
        });
      }
    } else {
      return this.prisma.users.update({
        where: { user_id: id },
        data: updateData,
      });
    }
  }

  // remove(id: number) {
  //   return `This action removes a #${id} user`;
  // }
}
