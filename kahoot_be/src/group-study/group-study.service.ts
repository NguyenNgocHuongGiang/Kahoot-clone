import { Injectable } from '@nestjs/common';
import { CreateGroupStudyDto } from './dto/create-group-study.dto';
import { UpdateGroupStudyDto } from './dto/update-group-study.dto';
import { PrismaClient } from '@prisma/client';
import { CreateGroupMemberDto } from './dto/create-member.dto';
import { SendMessageDto } from './dto/send-message.dto';

@Injectable()
export class GroupStudyService {
  prisma = new PrismaClient();

  async create(data: CreateGroupStudyDto) {
    return await this.prisma.groups.create({
      data,
    });
  }

  async addMember(data: CreateGroupMemberDto) {
    const { group_id, user_id } = data;

    const existingMember = await this.prisma.groupMembers.findFirst({
      where: {
        group_id,
        user_id,
      },
    });

    if (existingMember) {
      throw new Error('User đã là thành viên của nhóm!');
    }

    return this.prisma.groupMembers.create({
      data,
    });
  }

  async deleteMember(memberId: string) {
    const messages = await this.prisma.groupMessages.findMany({
      where: {
        user_id: Number(memberId),
      },
    });

    // Xóa tin nhắn nếu có
    if (messages.length > 0) {
      await this.prisma.groupMessages.deleteMany({
        where: { user_id: Number(memberId) },
      });
    }

    // Xóa member khỏi group
    return await this.prisma.groupMembers.delete({
      where: { member_id: Number(memberId) },
    });
  }

  async getGroupByGroupId(id: number) {
    return await this.prisma.groups.findUnique({
      where: {
        group_id: id,
      },
    });
  }

  async getMemberByGroupId(id: number) {
    // Lấy danh sách user_id, member_id và group_id từ groupMembers
    const groupMembers = await this.prisma.groupMembers.findMany({
      where: { group_id: id },
      select: {
        member_id: true, // Thêm member_id
        group_id: true, // Thêm group_id
        user_id: true, // Lấy user_id để join với bảng users
      },
    });

    // Trích xuất danh sách user_id từ kết quả truy vấn
    const userIds = groupMembers.map((member) => member.user_id);

    // Lấy thông tin user từ bảng users dựa trên danh sách user_id
    const users = await this.prisma.users.findMany({
      where: { user_id: { in: userIds } },
      select: {
        user_id: true,
        username: true,
        full_name: true,
        email: true,
      },
    });

    // Kết hợp dữ liệu từ bảng groupMembers và users
    const result = groupMembers.map((member) => {
      const user = users.find((user) => user.user_id === member.user_id);
      return {
        member_id: member.member_id,
        group_id: member.group_id,
        ...user, // Gộp thông tin user vào object
      };
    });

    return result;
  }

  async findOne(id: number) {
    return await this.prisma.groups.findMany({
      where: {
        created_by: id,
      },
    });
  }

  async update(id: number, data: UpdateGroupStudyDto) {
    return await this.prisma.groups.update({
      where: {
        group_id: id,
      },
      data,
    });
  }

  async remove(id: number) {
    await this.prisma.groupMessages.deleteMany({
      where: {
        group_id: id,
      },
    });

    await this.prisma.groupMembers.deleteMany({
      where: {
        group_id: id,
      },
    });

    return this.prisma.groups.delete({
      where: {
        group_id: id,
      },
    });
  }

  async sendMessage(data: SendMessageDto) {
    const message = await this.prisma.groupMessages.create({
      data,
    });
  
    // Lấy thông tin user từ bảng Users
    const user = await this.prisma.users.findUnique({
      where: { user_id: data.user_id },
      select: { username: true, email: true },
    });
  
    return {
      ...message,
      Users: user, // Thêm thông tin user vào tin nhắn
    };
  }

  async getMessages(group_id: number, page = 1, limit = 10) {
    const skip = (page - 1) * limit;

    const messages = await this.prisma.groupMessages.findMany({
      where: { group_id: Number(group_id) },
      orderBy: { sent_at: 'desc' },
      skip,
      take: Number(limit),
      include: {
        Users: { select: { username: true, email: true } },
      },
    });

    return messages;
  }

  async getGroupByUserId(userId: number) {
    const groups = await this.prisma.groupMembers.findMany({
      where: { user_id: userId },
      select: { group_id: true }, 
    });
  
    const groupIds = groups.map(g => g.group_id); 
  
    if (groupIds.length === 0) {
      return []; 
    }
  
    return await this.prisma.groups.findMany({
      where: { group_id: { in: groupIds } }, 
    });
  }
  
}
