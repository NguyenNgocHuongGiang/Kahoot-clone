import {
    WebSocketGateway,
    SubscribeMessage,
    MessageBody,
    WebSocketServer,
    ConnectedSocket,
  } from '@nestjs/websockets';
  import { Server, Socket } from 'socket.io';
  import { GroupStudyService } from './group-study.service';
  import { SendMessageDto } from './dto/send-message.dto';
  
  @WebSocketGateway({
    cors: {
      origin: '*', // Cấu hình CORS, cần sửa theo đúng domain của bạn
    },
  })
  export class GroupStudyGateway {
    @WebSocketServer()
    server: Server;
  
    constructor(private readonly groupStudyService: GroupStudyService) {}
  
    @SubscribeMessage('sendMessage')
    async handleSendMessage(
      @ConnectedSocket() client: Socket,
      @MessageBody() data: SendMessageDto,
    ) {
      try {
        const message = await this.groupStudyService.sendMessage(data);
  
        // Gửi tin nhắn tới tất cả người dùng trong nhóm
        this.server.to(`group_${data.group_id}`).emit('newMessage', message);
        
        return { status: 'success', message };
      } catch (error) {
        return { status: 'error', message: error.message };
      }
    }
  
    @SubscribeMessage('joinGroup')
    async handleJoinGroup(
      @ConnectedSocket() client: Socket,
      @MessageBody() data: { group_id: number }
    ) {
      client.join(`group_${data.group_id}`); // Thêm client vào room
      console.log(`Client ${client.id} joined group_${data.group_id}`);
    }
  
    @SubscribeMessage('leaveGroup')
    handleLeaveGroup(@ConnectedSocket() client: Socket, @MessageBody() groupId: number) {
      client.leave(`group_${groupId}`);
      console.log(`Client ${client.id} left group_${groupId}`);
    }
  }
  