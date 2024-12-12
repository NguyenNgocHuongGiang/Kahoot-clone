import { Expose } from "class-transformer";

export class QuizDto {
    @Expose()
    quiz_id: number;
    
    @Expose()
    title: string;
    
    @Expose()
    description: string;

    @Expose()
    creator: string; 

    @Expose()
    cover_image: string;

    @Expose()
    visibility: 'public' | 'private'; 

    @Expose()
    category: string; 

    @Expose()
    created_at: string; 

    constructor(partial: Partial<QuizDto>){
        Object.assign(this, partial);
      }
}