import { Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
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

  async update(id: number, updateOptionDto: UpdateOptionDto): Promise<OptionDto> {
    try {
      const option = await this.prisma.options.findUnique({
        where: { option_id: id },
      });

      if (!option) {
        throw new NotFoundException('Option not found');
      }

      const updatedOption = await this.prisma.options.update({
        where: { option_id: id },
        data: updateOptionDto,
      });
      return updatedOption;
    } catch (error) {
      throw new InternalServerErrorException(
        'An error occurred during update option',
      );
    }
  }

  // remove(id: number) {
  //   return `This action removes a #${id} option`;
  // }
}
