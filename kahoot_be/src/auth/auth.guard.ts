import { Injectable, CanActivate, ExecutionContext, NotFoundException } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();

    // Kiểm tra xem người dùng có token trong header hay không
    const token = request.headers['authorization'];

    if (!token) {
      throw new NotFoundException('Unauthorized. Please login first.');
    }

    return true;
  }
}
