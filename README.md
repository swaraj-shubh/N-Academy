# N Academy

# teacher =>
{
    "success": true,
    "message": "OK",
    "data": {
        "totalCourses": 2,
        "courses": [
            {
                "course": {
                    "_id": "695fe85bdc85ea6c28d09282",
                    "title": "DSA Mastery",
                    "description": "Complete DSA course",
                    "price": 499,
                    "currency": "INR",
                    "createdAt": "2026-01-08T17:24:43.782Z"
                },
                "totalStudents": 2,
                "students": [
                    {
                        "purchase": {
                            "pricePaid": 499,
                            "currency": "INR",
                            "paymentProvider": "manual",
                            "purchasedAt": "2026-01-08T17:42:22.715Z"
                        },
                        "progress": {
                            "completedVideos": [],
                            "completionPercentage": 0
                        },
                        "_id": "695fec7ed1feccd996d8a1f5",
                        "studentId": {
                            "_id": "695f7ce6c5505af0056dc590",
                            "email": "student1@test.com",
                            "createdAt": "2026-01-08T09:46:14.871Z"
                        },
                        "courseId": "695fe85bdc85ea6c28d09282",
                        "createdAt": "2026-01-08T17:42:22.725Z"
                    },
                    {
                        "purchase": {
                            "pricePaid": 499,
                            "currency": "INR",
                            "paymentProvider": "manual",
                            "purchasedAt": "2026-01-09T13:54:24.837Z"
                        },
                        "progress": {
                            "completedVideos": [],
                            "completionPercentage": 0
                        },
                        "_id": "696108904614a0e5b443e4df",
                        "studentId": {
                            "_id": "69601d4adbdd03a71bc790f6",
                            "email": "shubhh.ab@gmail.com",
                            "createdAt": "2026-01-08T21:10:34.494Z"
                        },
                        "courseId": "695fe85bdc85ea6c28d09282",
                        "createdAt": "2026-01-09T13:54:24.839Z"
                    }
                ]
            },
            {
                "course": {
                    "_id": "6961192ddf7f75b752ac1f61",
                    "title": "test",
                    "description": "test test test test",
                    "price": 201,
                    "currency": "INR",
                    "createdAt": "2026-01-09T15:05:17.383Z"
                },
                "totalStudents": 0,
                "students": []
            }
        ]
    }
}







# student =>

{
    "success": true,
    "message": "OK",
    "data": {
        "totalEnrolledCourses": 1,
        "courses": [
            {
                "purchase": {
                    "pricePaid": 499,
                    "currency": "INR",
                    "paymentProvider": "manual",
                    "purchasedAt": "2026-01-08T17:42:22.715Z"
                },
                "progress": {
                    "completedVideos": [],
                    "completionPercentage": 0
                },
                "_id": "695fec7ed1feccd996d8a1f5",
                "courseId": {
                    "_id": "695fe85bdc85ea6c28d09282",
                    "title": "DSA Mastery",
                    "description": "Complete DSA course",
                    "price": 499,
                    "currency": "INR",
                    "teacherId": {
                        "_id": "695fe0ea0c03079b02670507",
                        "email": "teacher1@test.com"
                    },
                    "createdAt": "2026-01-08T17:24:43.782Z"
                },
                "status": "active",
                "createdAt": "2026-01-08T17:42:22.725Z"
            }
        ]
    }
}
