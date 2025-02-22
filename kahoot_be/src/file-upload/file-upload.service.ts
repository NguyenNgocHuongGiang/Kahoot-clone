import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { v2 as cloudinary, UploadApiErrorResponse, UploadApiResponse } from 'cloudinary';
import { configureCloudinary } from 'src/config/cloudinary.config';

@Injectable()
export class FileUploadService {
  constructor(private configService: ConfigService) {
    configureCloudinary(this.configService);
  }

  async uploadFile(file: Express.Multer.File): Promise<string> {
    return new Promise((resolve, reject) => {
      cloudinary.uploader.upload_stream(
        { folder: 'appquizfox' },
        // { folder: 'kahoot_clone' },
        (error, result) => {
          if (error) {
            console.error('Cloudinary error:', error);
            reject(error);
          }
          console.log('Cloudinary upload result:', result); 
          resolve(result.secure_url);
        },
      ).end(file.buffer);
    });
  }
  
}
