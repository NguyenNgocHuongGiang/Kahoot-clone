import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpStatus,
  Res,
  UseGuards,
} from '@nestjs/common';
import { OptionsService } from './options.service';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { OptionDto } from './dto/option.dto';
import { PrismaClient } from '@prisma/client';
import { AuthGuard } from 'src/auth/auth.guard';

@ApiTags('Options')
@Controller('options')
export class OptionsController {
  constructor(private readonly questionService: OptionsService) {}

  @Post('/')
  // @ApiBearerAuth()
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  // @UseGuards(AuthGuard)
  async create(
    @Res() res: Response,
    @Body() createOptionDto: CreateOptionDto,
  ): Promise<Response<OptionDto>> {
    try {
      let newOption = await this.questionService.create({
        ...createOptionDto,
      });
      return res.status(HttpStatus.CREATED).json(newOption);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }

    // @Get()
    // findAll() {
    //   return this.optionsService.findAll();
    // }

    // @Get(':id')
    // findOne(@Param('id') id: string) {
    //   return this.optionsService.findOne(+id);
    // }

    // @Patch(':id')
    // update(@Param('id') id: string, @Body() updateOptionDto: UpdateOptionDto) {
    //   return this.optionsService.update(+id, updateOptionDto);
    // }

    // @Delete(':id')
    // remove(@Param('id') id: string) {
    //   return this.optionsService.remove(+id);
    // }
  }
}
