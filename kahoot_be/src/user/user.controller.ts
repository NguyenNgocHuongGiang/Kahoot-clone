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
  Put,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { User } from './entities/user.entity';
import { Response } from 'express';

@ApiTags('User')
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  // @Post()
  // create(@Body() createUserDto: CreateUserDto) {
  //   return this.userService.create(createUserDto);
  // }

  // @Get()
  // findAll() {
  //   return this.userService.findAll();
  // }

  @Get('/get-user/:id')
  @ApiResponse({ status: HttpStatus.OK, description: 'Get successfullly' })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async findOne(
    @Param('id') id: string,
    @Res() res: Response,
  ): Promise<Response<User>> {
    try {
      const userId = parseInt(id);
      const user = await this.userService.findOne(userId);
      if (!user) {
        throw new Error('User not found');
      }
      return res.status(HttpStatus.OK).json(user);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateData: UpdateUserDto, @Res() res: Response,
): Promise<Response<User>>{
    try {
      const userId = parseInt(id); // Convert id từ string sang number
      const updatedUser = await this.userService.update(userId, updateData);
      return res.status(HttpStatus.OK).json(updatedUser);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.userService.remove(+id);
  // }
}
