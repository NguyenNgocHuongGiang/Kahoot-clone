import { PartialType } from '@nestjs/swagger';
import { CreateSessionPlayerDto } from './create-session-player.dto';

export class UpdateSessionPlayerDto extends PartialType(CreateSessionPlayerDto) {}
