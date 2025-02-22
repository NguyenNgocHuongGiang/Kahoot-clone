import {
  BadRequestException,
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { FileUploadService } from './file-upload.service';
import { ApiBody, ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';

@Controller('file-upload')
@ApiTags('file-upload')
export class FileUploadController {
  constructor(private fileUploadService: FileUploadService) {}

  @Post()
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  async uploadFile(@UploadedFile() file: Express.Multer.File) {
    try {
      if (!file) {
        throw new BadRequestException('No file uploaded');
      }
      const maxSize = 1 * 1024 * 1024 * 1024;
      if (file.size > maxSize) {
        throw new BadRequestException(
          'File size is too large. Max file size is 1GB',
        );
      }
      console.log(file.mimetype);
      
      const imageUrl = await this.fileUploadService.uploadFile(file);
      return { imageUrl };
    } catch (error) {
      console.error(error);
      throw new Error(error.message);
    }
  }
}
