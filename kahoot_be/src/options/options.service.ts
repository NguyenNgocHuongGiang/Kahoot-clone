import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';
import { OptionDto } from './dto/option.dto';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class OptionsService {
  prisma = new PrismaClient();

  async create(body: CreateOptionDto): Promise<OptionDto> {
    try {
      const newOption = await this.prisma.options.create({
        data: body,
      });
      return newOption;
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during create option',
      );
    }
  }

  // findAll() {
  //   return `This action returns all options`;
  // }

  // findOne(id: number) {
  //   return `This action returns a #${id} option`;
  // }

  // update(id: number, updateOptionDto: UpdateOptionDto) {
  //   return `This action updates a #${id} option`;
  // }

  // remove(id: number) {
  //   return `This action removes a #${id} option`;
  // }
}
