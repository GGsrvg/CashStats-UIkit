//
//  CategoryCase.swift
//  BL
//
//  Created by GGsrvg on 04.07.2021.
//

import Combine
import CoreData
import DB

public class CategoryCase {
    public func get(predicate: NSPredicate? = nil) -> AnyPublisher<[CategoryEntity], Error> {
        return Deferred { Future<[CategoryEntity], Error> { promise in
            do {
                let models = try BL.current.db.fetch(
                    type: CategoryEntity.self,
                    predicate: predicate
                )
                promise(.success(models))
            } catch {
                promise(.failure(error))
            }
        } }.eraseToAnyPublisher()
    }
    
    public func add(models: [CategoryEntity]) -> AnyPublisher<Void, Error> {
        return Deferred { Future<Void, Error> { promise in
            do {
                models.forEach { BL.current.db.context.insert($0) }
                try BL.current.db.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        } }.eraseToAnyPublisher()
    }
    
    public func update() -> AnyPublisher<Void, Error> {
        return Deferred { Future<Void, Error> { promise in
            do {
                try BL.current.db.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        } }.eraseToAnyPublisher()
    }
    
    public func delete(models: [CategoryEntity]) -> AnyPublisher<Void, Error> {
        return Deferred { Future<Void, Error> { promise in
            do {
                models.forEach { BL.current.db.context.delete($0) }
                try BL.current.db.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        } }.eraseToAnyPublisher()
    }
}
