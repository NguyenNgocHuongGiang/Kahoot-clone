import { ApiProperty } from '@nestjs/swagger';

export class CreateQuizDto { 
  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty()
  creator: string;

  @ApiProperty()
  cover_image: string;

  @ApiProperty()
  visibility: 'public' | 'private';

  @ApiProperty()
  category: string;

  constructor(partial: Partial<CreateQuizDto>) {
    Object.assign(this, partial);
  }
}
