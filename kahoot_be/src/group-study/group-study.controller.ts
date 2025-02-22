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
  Query,
} from '@nestjs/common';
import { GroupStudyService } from './group-study.service';
import { CreateGroupStudyDto } from './dto/create-group-study.dto';
import { UpdateGroupStudyDto } from './dto/update-group-study.dto';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { CreateGroupMemberDto } from './dto/create-member.dto';
import { SendMessageDto } from './dto/send-message.dto';
import { GetMessagesDto } from './dto/get-message.dto';

@ApiTags('GroupStudy')
@Controller('group-study')
export class GroupStudyController {
  constructor(private readonly groupStudyService: GroupStudyService) {}

  @Post('/')
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async create(
    @Res() res: Response,
    @Body() data: CreateGroupStudyDto,
  ): Promise<Response<any>> {
    try {
      let newGroup = await this.groupStudyService.create(data);
      return res.status(HttpStatus.CREATED).json(newGroup);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Post('add-member')
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Create successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async addMember(
    @Res() res: Response,
    @Body() data: CreateGroupMemberDto,
  ): Promise<Response<any>> {
    try {
      let newMember = await this.groupStudyService.addMember(data);
      return res.status(HttpStatus.CREATED).json(newMember);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  // @Get()
  // findAll() {
  //   return this.groupStudyService.findAll();
  // }

  @Get('/get-my-group/:id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async findOne(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      let groups = await this.groupStudyService.findOne(+id);
      return res.status(HttpStatus.OK).json(groups);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Get('/get-by-groupId/:id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getGroupByGroupId(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      let group = await this.groupStudyService.getGroupByGroupId(+id);
      return res.status(HttpStatus.OK).json(group);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Get('/get-member/:id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getMember(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      let members = await this.groupStudyService.getMemberByGroupId(+id);
      return res.status(HttpStatus.OK).json(members);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Delete('/delete-member/:id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async deleteMember(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      let members = await this.groupStudyService.deleteMember(id);
      return res.status(HttpStatus.OK).json(members);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Put(':id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Update successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async update(
    @Res() res: Response,
    @Param('id') id: string,
    @Body() data: UpdateGroupStudyDto,
  ): Promise<Response<any>> {
    try {
      let group = await this.groupStudyService.update(+id, data);
      return res.status(HttpStatus.OK).json(group);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Delete(':id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Delete successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async remove(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      let groupDeleted = await this.groupStudyService.remove(+id);
      return res.status(HttpStatus.OK).json(groupDeleted);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Post('send-message')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Send successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async sendMessage(
    @Res() res: Response,
    @Body() data: SendMessageDto,
  ): Promise<Response<any>> {
    try {
      let messageSendInf = await this.groupStudyService.sendMessage(data);
      return res.status(HttpStatus.OK).json(messageSendInf);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Get('messages')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getMessages(@Res() res: Response, @Query() query: GetMessagesDto) : Promise<Response<any>> {
    try {
      const { group_id, page, limit } = query;
      let messagess = await this.groupStudyService.getMessages(group_id, page, limit);
      return res.status(HttpStatus.OK).json(messagess);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }

  @Get('/get-shared_group/:id')
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get successfullly',
  })
  @ApiResponse({
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: 'Internal Server',
  })
  async getSharedGroup(
    @Res() res: Response,
    @Param('id') id: string,
  ): Promise<Response<any>> {
    try {
      let groups = await this.groupStudyService.getGroupByUserId(+id);
      return res.status(HttpStatus.OK).json(groups);
    } catch (error) {
      return res
        .status(HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }
  }
}
