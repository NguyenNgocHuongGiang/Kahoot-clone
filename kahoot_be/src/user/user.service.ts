import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaClient } from '@prisma/client';
import { User } from './entities/user.entity';
import * as bcrypt from 'bcrypt';
import { QuizService } from 'src/quiz/quiz.service';

@Injectable()
export class UserService {
  prisma = new PrismaClient();
    constructor(private readonly quizService: QuizService) {}

  // create(createUserDto: CreateUserDto) {
  //   return 'This action adds a new user';
  // }

  async findAll(): Promise<User[]> {
    return this.prisma.users.findMany();
  }  

  async findOne(id: number): Promise<User> {
    return this.prisma.users.findUnique({
      where: { user_id: id },
    });
  }

  async getUserByEmail(email: string): Promise<User> {
    return this.prisma.users.findUnique({
      where: { email: email },
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

  async getTopCreators(): Promise<any> {
    try {
      const sortedQuizzes = await this.quizService.getTopQuiz()
  
      // Tạo một đối tượng lưu tổng số lượt chơi theo creator_id
      const playerCountByCreator: Record<number, number> = {};
      sortedQuizzes.forEach((quiz) => {
        const creatorId = quiz.creator;
        playerCountByCreator[creatorId] =
          (playerCountByCreator[creatorId] || 0) + quiz.totalPlayers;
      });
  
      // Lấy danh sách người dùng có quiz được chơi nhiều nhất
      const topCreators = Object.entries(playerCountByCreator)
        .map(([creatorId, totalPlayers]) => ({
          creatorId: Number(creatorId),
          totalPlayers,
        }))
        .sort((a, b) => b.totalPlayers - a.totalPlayers)
        .slice(0, 5);
  
      // Lấy thông tin người dùng từ database
      const users = await this.prisma.users.findMany({
        where: { user_id: { in: topCreators.map((c) => c.creatorId) } },
        select: { user_id: true, username: true, avatar: true },
      });
  
      // Gộp dữ liệu creator với thông tin người dùng
      const finalCreators = topCreators.map((creator) => ({
        ...creator,
        username: users.find((u) => u.user_id === creator.creatorId)?.username || 'Unknown',
        avatar: users.find((u) => u.user_id === creator.creatorId)?.avatar || 'Unknown',
      }));
  
      return { topCreators: finalCreators };
  
    } catch (error) {
      throw new Error(error);
    }
  }
  
  // remove(id: number) {
  //   return `This action removes a #${id} user`;
  // }
}
