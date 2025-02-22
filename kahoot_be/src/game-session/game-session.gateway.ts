import {
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { PrismaClient } from '@prisma/client';
import { log } from 'console';
import { Server, Socket } from 'socket.io';

@WebSocketGateway()
export class GameSessionGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer() server: Server;

  prisma = new PrismaClient();

  private waitingRooms: Record<string, { id: string; nickname: string }[]> = {};

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
    for (const pin in this.waitingRooms) {
      this.waitingRooms[pin] = this.waitingRooms[pin].filter(
        (c) => c.id !== client.id,
      );
      if (this.waitingRooms[pin].length > 0) {
        this.server.to(pin).emit('player-left', { clientId: client.id });
        this.server
          .to(pin)
          .emit('count-player', { count: this.waitingRooms[pin].length });
      } else {
        delete this.waitingRooms[pin];
      }
    }
  }

  @SubscribeMessage('join-room')
  async handleJoinRoom(
    client: Socket,
    payload: { pin: string; nickname: string },
  ) {
    console.log('join-room', payload);

    const { pin, nickname } = payload;

    if (this.waitingRooms[pin]?.some((c) => c.id === client.id)) {
      console.log(`Client ${client.id} is already in the room ${pin}`);
      return;
    }

    if (!this.waitingRooms[pin]) {
      this.waitingRooms[pin] = [];
    }

    this.waitingRooms[pin].push({ id: client.id, nickname: nickname });

    client.join(pin);

    this.server.to(pin).emit('player-joined', { nickname });
    this.emitPlayerCount(pin);
    this.emitPlayerList(pin);
  }
  // else{
  //   console.log(`Session with PIN ${pin} is not active or does not exist`);
  //   client.emit('error', {
  //     message: 'Session is not active or does not exist.',
  //   });
  // }
  // }

  @SubscribeMessage('start-game')
  async handleStartGame(client: Socket, pin: string) {
    if (this.waitingRooms[pin] && this.waitingRooms[pin].length > 1) {
      this.server.to(pin).emit('game-started');
    } else {
      client.emit('not-enough-players', {
        message: 'Not enough players to start the game!',
      });
    }
  }

  @SubscribeMessage('start-countdown')
  handleStartCountdown(
    client: Socket,
    payload: { pin: string; countdown: number },
  ) {
    const { pin, countdown } = payload;
    if (this.waitingRooms[pin] && this.waitingRooms[pin].length > 1) {
      console.log(
        `Starting countdown for room ${pin} with ${countdown} seconds`,
      );
      let remainingTime = countdown;

      const countdownInterval = setInterval(() => {
        remainingTime--;
        this.server.to(pin).emit('countdown-tick', { remainingTime });
        if (remainingTime <= 0) {
          clearInterval(countdownInterval);
          this.server.to(pin).emit('countdown-finished');
        }
      }, 1500);
    } else {
      client.emit('not-enough-players', {
        message: 'Not enough players to start the countdown!',
      });
    }
  }

  @SubscribeMessage('nickname-changed')
  handleNicknameChanged(
    client: Socket,
    payload: { nickname: string; pin: string; sessionPlayerId: string },
  ) {
    const { nickname, pin, sessionPlayerId } = payload;

    console.log(nickname, pin);

    const player = this.waitingRooms[pin]?.find((p) => p.id === client.id);

    if (player) {
      player.nickname = nickname;

      this.server.to(pin).emit('nickname-updated', {
        clientId: client.id,
        newNickname: nickname,
      });

      this.emitPlayerList(pin);

      console.log(`Player ${client.id} updated nickname to ${nickname}`);
    }
  }

  @SubscribeMessage('update-score')
  handleUpdateScore(
    client: Socket,
    payload: { pin: string; score: number; user_id: number },
  ) {
    const { pin, score, user_id } = payload;

    this.server.to(pin).emit('score-updated', {
      userId: user_id,
      clientId: client.id,
      score: score,
    });

    console.log(
      `Score updated for client ${client.id} in room ${pin}: ${score}`,
    );
  }

  private emitPlayerCount(pin: string) {
    const playerCount = this.waitingRooms[pin]?.length || 0;
    console.log(`Player count for room ${pin}: ${playerCount}`);
    this.server.to(pin).emit('player-count', { count: playerCount });
  }

  private emitPlayerList(pin: string) {
    const players = this.waitingRooms[pin]?.map((p) => p.nickname) || [];
    console.log(`Player list for room ${pin}: ${players}`);
    this.server.to(pin).emit('player-list', { players });
  }
}
