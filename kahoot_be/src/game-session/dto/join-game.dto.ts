import { ApiProperty } from '@nestjs/swagger';

export class JoinGameSessionDto {
  @ApiProperty()
  pin: string;
}
