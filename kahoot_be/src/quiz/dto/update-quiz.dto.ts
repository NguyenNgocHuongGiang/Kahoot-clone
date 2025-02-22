import { ApiProperty } from '@nestjs/swagger';

export class UpdateQuizDto {
  @ApiProperty({ required: false })
  title?: string;

  @ApiProperty({ required: false })
  description?: string;

  @ApiProperty({ required: false })
  cover_image?: string;

  @ApiProperty({ required: false })
  visibility?: 'public' | 'private';

  @ApiProperty({ required: false })
  category?: string;
}
